import Sound
import lean_certs.cert_33_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_96_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 33) (d := 96) (c := cert_33_96) (by decide)
