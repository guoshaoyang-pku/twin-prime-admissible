import Sound
import lean_certs.cert_17_52

open CertVerify

theorem H17_gt_52 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 17) (d := 52) (c := cert_17_52) (by native_decide)
