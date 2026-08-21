import Sound
import lean_certs.cert_44_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_96_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 44) (d := 96) (c := cert_44_96) (by decide)
