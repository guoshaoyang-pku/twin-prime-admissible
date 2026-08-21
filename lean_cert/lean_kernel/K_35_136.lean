import Sound
import lean_certs.cert_35_136

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_136_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 35) (d := 136) (c := cert_35_136) (by decide)
