import Sound
import lean_certs.cert_18_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_62_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 18) (d := 62) (c := cert_18_62) (by decide)
