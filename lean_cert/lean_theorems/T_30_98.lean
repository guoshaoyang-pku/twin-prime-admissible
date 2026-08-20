import Sound
import lean_certs.cert_30_98

open CertVerify

theorem H30_gt_98 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 30) (d := 98) (c := cert_30_98) (by native_decide)
