import Sound
import lean_certs.cert_27_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_96_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 27) (d := 96) (c := cert_27_96) (by decide)
