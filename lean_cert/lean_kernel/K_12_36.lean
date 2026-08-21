import Sound
import lean_certs.cert_12_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_36_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 12) (d := 36) (c := cert_12_36) (by decide)
