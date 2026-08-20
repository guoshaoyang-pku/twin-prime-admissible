import Sound
import lean_certs.cert_23_86

open CertVerify

theorem H23_gt_86 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 23) (d := 86) (c := cert_23_86) (by native_decide)
