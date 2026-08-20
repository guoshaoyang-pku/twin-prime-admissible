import Sound
import lean_certs.cert_31_96

open CertVerify

theorem H31_gt_96 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 31) (d := 96) (c := cert_31_96) (by native_decide)
