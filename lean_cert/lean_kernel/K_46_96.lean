import Sound
import lean_certs.cert_46_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_96_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 46) (d := 96) (c := cert_46_96) (by decide)
