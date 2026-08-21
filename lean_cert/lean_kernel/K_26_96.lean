import Sound
import lean_certs.cert_26_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_96_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 26) (d := 96) (c := cert_26_96) (by decide)
