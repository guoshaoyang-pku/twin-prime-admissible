import Sound
import lean_certs.cert_21_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_62_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 21) (d := 62) (c := cert_21_62) (by decide)
