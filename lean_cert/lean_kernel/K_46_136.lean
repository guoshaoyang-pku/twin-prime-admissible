import Sound
import lean_certs.cert_46_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_136_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 46) (d := 136) (c := cert_46_136) (by decide)
