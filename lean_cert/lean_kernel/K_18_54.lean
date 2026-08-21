import Sound
import lean_certs.cert_18_54

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_54_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 18) (d := 54) (c := cert_18_54) (by decide)
