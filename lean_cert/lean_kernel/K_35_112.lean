import Sound
import lean_certs.cert_35_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_112_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 35) (d := 112) (c := cert_35_112) (by decide)
