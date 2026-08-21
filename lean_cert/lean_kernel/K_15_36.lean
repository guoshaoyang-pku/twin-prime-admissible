import Sound
import lean_certs.cert_15_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_36_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 15) (d := 36) (c := cert_15_36) (by decide)
