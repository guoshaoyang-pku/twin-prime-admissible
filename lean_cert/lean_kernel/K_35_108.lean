import Sound
import lean_certs.cert_35_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_108_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 35) (d := 108) (c := cert_35_108) (by decide)
