import Sound
import lean_certs.cert_45_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_96_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 45) (d := 96) (c := cert_45_96) (by decide)
