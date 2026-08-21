import Sound
import lean_certs.cert_18_36

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_36_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 18) (d := 36) (c := cert_18_36) (by decide)
