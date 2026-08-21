import Sound
import lean_certs.cert_35_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_134_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 35) (d := 134) (c := cert_35_134) (by decide)
