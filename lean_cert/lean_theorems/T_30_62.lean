import Sound
import lean_certs.cert_30_62

open CertVerify

theorem H30_gt_62 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 30) (d := 62) (c := cert_30_62) (by native_decide)
