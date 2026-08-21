import Sound
import lean_certs.cert_35_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_88_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 35) (d := 88) (c := cert_35_88) (by decide)
