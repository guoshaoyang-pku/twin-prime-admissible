import Sound
import lean_certs.cert_22_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_62_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 22) (d := 62) (c := cert_22_62) (by decide)
