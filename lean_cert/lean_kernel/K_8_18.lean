import Sound
import lean_certs.cert_8_18

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H8_gt_18_kernel : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 8) (d := 18) (c := cert_8_18) (by decide)
