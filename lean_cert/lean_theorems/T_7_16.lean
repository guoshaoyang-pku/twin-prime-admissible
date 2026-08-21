import Sound
import lean_certs.cert_7_16

open CertVerify

theorem H7_gt_16 : ¬ ∃ t : List Nat, admissible 7 t = true ∧ diameter t ≤ 16 := by
  exact certValidRoot_sound (k := 7) (d := 16) (c := cert_7_16) (by native_decide)
