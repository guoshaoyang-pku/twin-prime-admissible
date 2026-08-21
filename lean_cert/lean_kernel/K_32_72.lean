import Sound
import lean_certs.cert_32_72

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_72_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 32) (d := 72) (c := cert_32_72) (by decide)
