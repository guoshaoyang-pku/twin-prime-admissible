import Sound
import lean_certs.cert_31_104

open CertVerify

theorem H31_gt_104 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 31) (d := 104) (c := cert_31_104) (by native_decide)
