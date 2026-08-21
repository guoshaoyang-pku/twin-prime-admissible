import Sound
import lean_certs.cert_43_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_96_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 43) (d := 96) (c := cert_43_96) (by decide)
