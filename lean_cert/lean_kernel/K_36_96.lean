import Sound
import lean_certs.cert_36_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_96_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 36) (d := 96) (c := cert_36_96) (by decide)
