import Sound
import lean_certs.cert_28_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_96_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 28) (d := 96) (c := cert_28_96) (by decide)
