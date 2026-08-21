import Sound
import lean_certs.cert_39_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_96_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 39) (d := 96) (c := cert_39_96) (by decide)
