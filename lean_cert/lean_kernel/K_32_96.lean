import Sound
import lean_certs.cert_32_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_96_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 32) (d := 96) (c := cert_32_96) (by decide)
