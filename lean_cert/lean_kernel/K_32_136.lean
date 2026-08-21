import Sound
import lean_certs.cert_32_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_136_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 32) (d := 136) (c := cert_32_136) (by decide)
