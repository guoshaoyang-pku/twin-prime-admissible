import Sound
import lean_certs.cert_14_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H14_gt_36_kernel : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 14) (d := 36) (c := cert_14_36) (by decide)
