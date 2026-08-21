import Sound
import lean_certs.cert_49_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_96_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 49) (d := 96) (c := cert_49_96) (by decide)
