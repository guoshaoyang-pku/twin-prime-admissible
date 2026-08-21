import Sound
import lean_certs.cert_32_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_132_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 32) (d := 132) (c := cert_32_132) (by decide)
