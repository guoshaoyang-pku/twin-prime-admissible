import Sound
import lean_certs.cert_26_80

open CertVerify

theorem H26_gt_80 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 26) (d := 80) (c := cert_26_80) (by native_decide)
