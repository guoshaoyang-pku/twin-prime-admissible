import Sound
import lean_certs.cert_24_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_96_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 24) (d := 96) (c := cert_24_96) (by decide)
