import Sound
import lean_certs.cert_32_142

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H32_gt_142_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 32) (d := 142) (c := cert_32_142) (by decide)
