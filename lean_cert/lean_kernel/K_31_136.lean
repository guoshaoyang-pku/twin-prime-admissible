import Sound
import lean_certs.cert_31_136

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H31_gt_136_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 31) (d := 136) (c := cert_31_136) (by decide)
