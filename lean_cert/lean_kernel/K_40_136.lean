import Sound
import lean_certs.cert_40_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_136_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 40) (d := 136) (c := cert_40_136) (by decide)
