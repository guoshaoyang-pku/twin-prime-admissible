import Sound
import lean_certs.cert_34_86

open CertVerify

theorem H34_gt_86 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 34) (d := 86) (c := cert_34_86) (by native_decide)
