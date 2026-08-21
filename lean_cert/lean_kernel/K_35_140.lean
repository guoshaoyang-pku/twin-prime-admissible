import Sound
import lean_certs.cert_35_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_140_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 35) (d := 140) (c := cert_35_140) (by decide)
