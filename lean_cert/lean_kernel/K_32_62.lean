import Sound
import lean_certs.cert_32_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_62_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 32) (d := 62) (c := cert_32_62) (by decide)
