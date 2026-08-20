import Sound
import lean_certs.cert_31_86

open CertVerify

theorem H31_gt_86 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 31) (d := 86) (c := cert_31_86) (by native_decide)
