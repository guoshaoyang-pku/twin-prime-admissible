import Sound
import lean_certs.cert_43_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_136_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 43) (d := 136) (c := cert_43_136) (by decide)
