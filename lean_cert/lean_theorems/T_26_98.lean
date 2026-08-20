import Sound
import lean_certs.cert_26_98

open CertVerify

theorem H26_gt_98 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 26) (d := 98) (c := cert_26_98) (by native_decide)
