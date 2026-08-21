import Sound
import lean_certs.cert_45_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_140_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 45) (d := 140) (c := cert_45_140) (by decide)
