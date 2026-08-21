import Sound
import lean_certs.cert_50_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_136_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 50) (d := 136) (c := cert_50_136) (by decide)
