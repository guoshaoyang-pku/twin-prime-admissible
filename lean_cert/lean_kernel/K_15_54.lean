import Sound
import lean_certs.cert_15_54

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_54_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 15) (d := 54) (c := cert_15_54) (by decide)
