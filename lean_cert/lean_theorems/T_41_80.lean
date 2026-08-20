import Sound
import lean_certs.cert_41_80

open CertVerify

theorem H41_gt_80 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 41) (d := 80) (c := cert_41_80) (by native_decide)
