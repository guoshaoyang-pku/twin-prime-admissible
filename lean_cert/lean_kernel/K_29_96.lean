import Sound
import lean_certs.cert_29_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_96_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 29) (d := 96) (c := cert_29_96) (by decide)
