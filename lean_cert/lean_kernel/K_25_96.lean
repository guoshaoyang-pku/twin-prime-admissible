import Sound
import lean_certs.cert_25_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_96_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 25) (d := 96) (c := cert_25_96) (by decide)
