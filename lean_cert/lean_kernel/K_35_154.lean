import Sound
import lean_certs.cert_35_154

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H35_gt_154_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 35) (d := 154) (c := cert_35_154) (by decide)
