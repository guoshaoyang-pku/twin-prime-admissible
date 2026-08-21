import Sound
import lean_certs.cert_37_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_96_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 37) (d := 96) (c := cert_37_96) (by decide)
